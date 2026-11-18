"""Validate menu coverage, legal profile values and Custom matching behavior."""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def check():
    text = (ROOT / 'shaders/shaders.properties').read_text()
    text = re.sub(r'\\\r?\n[ \t]*', ' ', text)
    settings = (ROOT / 'shaders/lib/settings.glsl').read_text()
    allowed = {}
    for line in settings.splitlines():
        match = re.search(r'(?:#define\s+(\w+)|const\s+\w+\s+(\w+)\s*=).*//\s*\[([^]]+)\]', line)
        if match:
            allowed[match[1] or match[2]] = match[3].split()
    profiles = {name: dict(token.split('=', 1) for token in values.split())
                for name, values in re.findall(r'^profile\.(\w+)=(.*)$', text, re.MULTILINE)}
    controls = set()
    for screen, elements in re.findall(r'^screen\.([^=]+)=(.*)$', text, re.MULTILINE):
        if screen.startswith('PERF_') or screen == 'APPLE_SETTINGS':
            controls.update(token for token in elements.split()
                            if not token.startswith(('[', '<')))
    if set(profiles) != {'FAST', 'BALANCED', 'CRISP'}:
        raise ValueError(f'Unexpected profile names: {sorted(profiles)}')
    for name, options in profiles.items():
        missing = controls - options.keys()
        if missing:
            raise ValueError(f'{name} is missing menu controls: {sorted(missing)}')
        for key, value in options.items():
            if value not in allowed.get(key, ()):
                raise ValueError(f'{name}: invalid setting {key}={value}')
        # Native Iris chooses Custom when no full profile matches the changed options.
        for key in controls:
            for alternative in allowed[key]:
                if alternative == options[key]:
                    continue
                changed = dict(options, **{key: alternative})
                if any(all(changed.get(k) == v for k, v in other.items())
                       for other in profiles.values()):
                    raise ValueError(f'{name}: changing {key} to {alternative} must select Custom')
    expected = {
        'FAST': {'SDV_CLOUD_LAYERS': '1', 'WATER_REFLECTIONS': '0',
                 'WET_GROUND_REFLECTIONS': '0', 'MAX_AO': '0', 'MAX_SUNBEAMS': '0', 'SHADOWS': '1'},
        'BALANCED': {'FOLIAGE_WIND': '1', 'CUSTOM_WATER': '1', 'WATER_REFLECTIONS': '2'},
    }
    for name, settings in expected.items():
        for key, value in settings.items():
            if profiles[name].get(key) != value:
                raise ValueError(f'{name} must set {key}={value}')
    if any(profile.get('FXAA') != '0' for profile in profiles.values()):
        raise ValueError('Every profile must disable FXAA')
    if 'program.shadow.enabled=false' not in text:
        raise ValueError('Missing shadow program disable setting')
    print(f'Validated three profiles and Custom matching for {len(controls)} performance controls.')

if __name__ == '__main__':
    check()
