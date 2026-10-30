# Layout algebra and ownership

Before a kernel can move data, it needs to answer two questions: which storage position does a coordinate identify, and which thread handles that position? This section develops those mappings using small examples that can be traced by hand.

Begin with shape and stride, then follow the lessons in order. Each new operation builds on the coordinate vocabulary established by the previous examples.

| Lesson | Follow the example to learn how to… |
| --- | --- |
| [00 · Shapes and strides](00-shapes-and-strides/README.md) | Map a matrix coordinate to an offset and distinguish logical size from storage span. |
| [01 · Coordinates and views](01-coordinates-and-views/README.md) | Expand a scalar coordinate, apply strides, and combine a layout with storage. |
| [02 · Nested layouts](02-nested-layouts/README.md) | Read a coordinate tree and calculate each leaf's contribution to an offset. |
| [03 · Composition](03-composition/README.md) | Pass one mapping's result through another layout's logical domain. |
| [04 · Coalescing](04-coalescing/README.md) | Simplify coordinate structure while preserving the ordered offset sequence. |
| [05 · Divide into windows](05-logical-divide/README.md) | Separate local and tile coordinates using logical, zipped, tiled, and flat divide. |
| [06 · Select a block tile](06-select-block-tile/README.md) | Select a window with the block ID and index within it using the thread ID. |
| [07 · Give each thread two values](07-thread-value-layouts/README.md) | Map thread/value coordinates to two owned positions per thread. |

In each lesson, start with the diagram and trace its highlighted example. Complete the matching `practice.py`, run its checker, then compare the commented `solution.py`. Run commands from the repository root in the [configured GPU environment](../../README.md#set-up-and-start).

Lessons 00–04 evaluate mappings and record their offsets. The divide tutorials and lesson 06 use selected views to load or copy data. Lesson 07 isolates ownership before the next section combines it with a copy operation.

After this section, continue to [GPU data movement and execution](../01-gpu-programming/README.md).

[Course overview](../../README.md) · [Roadmap](../../ROADMAP.md)
