sassc = find_program('sassc', required: true)

style = custom_target('Style generation',
    input: ['main.scss'],
    output:'style.css',
    command: [
        sassc,
        [ '-a', '-M', '-t', 'compact' ],
        '@INPUT@', '@OUTPUT@',
    ],
    depend_files: files([
        '_buttons.scss',
        '_menu.scss',
        '_userbox.scss',
        '_vars.scss',
    ]),
    build_by_default: true,
)
