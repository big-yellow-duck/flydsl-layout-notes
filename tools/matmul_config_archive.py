"""Translate archived matmul report fields for research reproduction tools."""


def config_from_archive(config_type, values):
    aliases = {
        "block_m": "group_tile_m",
        "block_n": "group_tile_n",
        "block_k": "stage_k",
        "waves_m": "waves_per_group_m",
        "waves_n": "waves_per_group_n",
        "group_m": "traversal_group_m",
        "wave_groups": "wave_groups_n",
    }
    values = dict(values)
    for old, current in aliases.items():
        if old in values:
            values.setdefault(current, values.pop(old))
    return config_type(**values)
