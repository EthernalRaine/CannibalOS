import pathlib

path = pathlib.Path("publish/amd64/iso/a")  # we insert "a" to get it to make directories, python funnies idfk
path.parent.mkdir(parents=True, exist_ok=True)

path = pathlib.Path("build/amd64/boot/a")
path.parent.mkdir(parents=True, exist_ok=True)

path = pathlib.Path("docs")
path.parent.mkdir(parents=True, exist_ok=True)
