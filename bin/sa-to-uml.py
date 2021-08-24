#!/usr/bin/env python3
import codecs

import sadisplay

from webapp.curative_db import models

desc = sadisplay.describe(
    [getattr(models, attr) for attr in dir(models)],
    show_methods=True,
    show_properties=True,
    show_indexes=True,
)
with codecs.open("schema.plantuml", "w", encoding="utf-8") as f:
    f.write(sadisplay.plantuml(desc))
