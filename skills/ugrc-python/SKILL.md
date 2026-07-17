---
name: ugrc-python
description: Use this skill when writing python code
---

Prefer the `pathlib` library over the older `os.path` module for handling filesystem paths. Be aware that the `arcpy` library does not support `pathlib.Path` objects directly prior to version 3.7; you will need to convert them to strings using `str(path)`. In version 3.7 and later, `arcpy` can handle `pathlib.Path` objects directly and can even be set to return them by default using this environment variable:

```python
arcpy.env.returnPathlib = True
```
