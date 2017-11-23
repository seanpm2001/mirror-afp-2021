Web site & Site generator
-------------------------

The web site is generated by a set of Python scripts. As input, they take

-   the metadata of the entries (as specified in the `metadata` folder),
-   dependencies between entries (as generated by the `afp_dependencies` tool),
    and
-   static templates (in `admin/sitegen-lib/templates`)

The output will be written to the `web` folder, which is supposed to be
committed into the repository. It can be inspected by opening any of the
contained HTML files in the browser.

The script can be invoked without any arguments:

    ./admin/sitegen

Optionally, the following flags can be supplied:

-   `--check`

    The script will perform a check whether the entries in the metadata file
    corresponds to the folders in the filesystem.

    You might want to specify `--no-warn` when using `--check` if you're only
    interested in checking the rough structure of the metadata file.

-   `--no-warn`

    Disable warnings. The script will occasionally complain about
    various things:

    *   missing keys in metadata file
    *   release of unknown entry
    *   release matches no known Isabelle version (i.e. release is 'too early')
    *   unknown topic is used in metadata

-   `--debug`

    Enables debug output. Each generator will print its representation of the
    data.

Changing static content, e.g. the submission guidelines, works by editing the
appropriate template file (see above) and re-running the `sitegen` script.