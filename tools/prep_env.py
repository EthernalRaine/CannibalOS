import pathlib

# ldr

path = pathlib.Path("publish/ldr/a")  # we insert "a" to get it to make directories, python funnies idfk
path.parent.mkdir(parents=True, exist_ok=True)

path = pathlib.Path("build/ldr/a")
path.parent.mkdir(parents=True, exist_ok=True)

