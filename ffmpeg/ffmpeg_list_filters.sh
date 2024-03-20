# Ref: https://stackoverflow.com/questions/69251087/in-ffmpeg-command-line-how-to-show-all-filter-settings-and-their-parameters-bef
#      https://ffmpeg.org/ffmpeg-filters.html

# list filters
ffmpeg -filters

# Show filter parameters:
ffmpeg --help filter=<filter_name>

# Example:
ffmpeg --help filter=zoompan
