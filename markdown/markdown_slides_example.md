# Examples to show graph with Slides

Install Slides:
```bash
brew install slides  # MacOS
go install github.com/maaslalani/slides@latest  # Go
```

Using:
```bash
slides file.md
```

Note: must pass a file that has execution permissions for the slides to be pre-processed.
```bash
chmod +x file.md
```

## Render graph with graph-easy
Depend on tool: apt install libgraph-easy-perl

- Example 1
```
~~~graph-easy --as=boxart
[ A ] - to -> [ B ]
~~~
```

- Example 2
```
~~~graph-easy --as=boxart
[ A ] -> [ B ], [ C ], [ D ]
~~~
```

---

- Example 3
```
~~~graph-easy --as=boxart
[ Bonn ] -> [ Berlin ]
[ Berlin ] -> [ Frankfurt ] { border: 1px dotted black; }
[ Frankfurt ] -> [ Dresden ]
[ Berlin ] ..> [ Potsdam ]
[ Potsdam ] => [ Cottbus ]
~~~
```

- Example 4
```
~~~graph-easy --as=boxart
[ Long Node Label\l left\r right\c center ]
 -- A\r long\n edge label --> [ B ]
~~~
```

---

- Example 4
```
~~~graph-easy --as=boxart
digraph {
    A -> B
}
~~~
```

- Example 5
```
~~~graph-easy --as=boxart
digraph {
    rankdir = LR;
    a -> b;
    b -> c;
}
~~~
```

---

## Render graph with PlantUML
Depend on tool:  apt install plantuml
- Example 1
```
~~~plantuml -utxt -pipe
@startuml
A --> B: to
@enduml
~~~
```

- Example 2
```
~~~plantuml -utxt -pipe
@startmindmap
# root node
## some first level node
### second level node
### another second level node
## another first level node
@endmindmap
~~~
```
