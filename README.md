# Actifish 🐟

A fish shell function to easily activate Python virtual envrionments.

## Why do I want Actifish?

It can be a pain to always type out `source .venv/bin/activate.fish`, especially
if you're in a subdirectory of your project: have you ever asked yourself "how
many `../`'s do I need from here," because I certainly have.

Sometimes you also want "global" virtual environments that you can activate from
anywhere. I use this to have an environment with NumPy, Pandas, and Matplotlib
for ad hoc data visualization handy. But it's annoying to have to type out the
`source` invocation for these too.

This single fish function solves both of these problems!

## How do I install Actifish?

Place a copy of the [activate.fish](activate.fish) file in
`~/.config/fish/functions/`. This allows fish to
[autoload](https://fishshell.com/docs/current/tutorial.html#autoloading-functions)
the function when you first call it.

Perhaps you can do this with the following cURL command:
```shell
curl -o ~/.config/fish/functions/activate.fish https://raw.githubusercontent.com/scolby33/actifish/refs/heads/main/activate.fish
```

## How do I use Actifish?

### Activating a Project's Virtual Environment

Just run `activate`. Actifish will search upwards in the directory hierarchy
until it finds a virtual environment and then activate it.

### Activating a Global Virtual Environment

First, you must create the virtual environment. By default, Actifish searches in
`~/.local/share/actifish/venvs`. Create that directory if it doesn't exist and
then create a virtual environment inside it using any method of your choice
(`python -m venv myglobalvenv`, `uv venv myglobalvenv`, `venv myglobalvenv`,
...).

Now, you can run `activate myglobalvenv` from anywhere on your system and
Actifish will activate that environment.

```console
$ mkdir -p ~/.local/share/actifish/venvs
$ cd ~/.local/share/actifish/venvs
$ uv venv myglobalenv
$ # you can cd to somewhere else now
$ activate myglobalenv
(myglobalvenv) $
```

If you would like to store your virtual environments in another location, set
the `$ACTIFISH_VENV_DIRS` variable (for example, in your `configuration.fish`):

```fish
set --path ACTIFISH_VENV_DIRS ~/.virtualenvs ~/.local/share/myothervenvs
```

Actifish treats `$ACTIFISH_VENV_DIRS` like the `$PATH`: it checks each element
of it in order and activates the first virtual environment that it finds.
