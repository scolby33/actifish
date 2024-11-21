# This file is a part of the Actifish project, which can be found at
# https://github.com/scolby33/actifish
#
# MIT License
#
# Copyright (c) 2024 Scott Colby
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

function activate -a name -d 'search upward for a virtualenv and activate the first; with an argument NAME, activate that virtualenv from the $ACTIFISH_VENV_DIRS'
    if test -n "$name"
        if not set --query ACTIFISH_VENV_DIRS
            set --path ACTIFISH_VENV_DIRS $HOME/.local/share/actifish/venvs
        end

        for venv_dir in $ACTIFISH_VENV_DIRS
            if test -f $venv_dir/$name/bin/activate.fish
                source $venv_dir/$name/bin/activate.fish
                return $status
            end
        end

        echo "'$name' doesn't exist or isn't a virtual environment within the \$ACTIFISH_VENV_DIRS" >&2
        return 66
    end

    set current_dir (pwd)
    set parent_dir (path dirname $current_dir)
    while test $current_dir != $parent_dir  # make sure we're not at the root
        if test -e $current_dir/pyvenv.cfg
            source $current_dir/bin/activate.fish
            return $status
        end
        for f in $current_dir/*/pyvenv.cfg $current_dir/.*/pyvenv.cfg
            source (path dirname $f)/bin/activate.fish
            return $status
        end
        set current_dir $parent_dir
        set parent_dir (path dirname $current_dir)
    end

    # one more iteration now that we've reached the root
    # (why are you storing a virtual environment at the root of your filesystem?)
    if test -e $current_dir/pyvenv.cfg
        source $current_dir/bin/activate.fish
        return $status
    end
    for f in $current_dir/*/pyvenv.cfg $current_dir/.*/pyvenv.cfg
        source (path dirname $f)/bin/activate.fish
        return $status
    end

    echo 'couldn\'t find a virtual environment to activate' >&2
    return 1
end
