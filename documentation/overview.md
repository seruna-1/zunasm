Zunasm is a collection of assembly procedures to deal with objects as described in language [zuna].

It also aims to be interoperable, but independent, from standard C library.

# Memory management

Objects are stored in blocks, and blocks are distributed over pages.

A page is a readable and writeable segment of memory obtained from the operating system through a syscall.

# Object

An object is a sequence of bytes. Part of them are information about the object itself (object metadata) and the rest is called object data.

The object data can be formed by many variable size sequences of bytes, depending on the object type. There is a sequence for the references to other objects, and a sequence with the adresses of the objects that reference this object.

The object metadata blocks contain the adresses of each data block, in order. When a null adress appears, it means that the sequence ended.

A reference consists of 16 bytes:

 - The adress of a referenced object.

 - The adress of a [names] object, containing the names associated with this reference.

# Block

The minimum size of a block is 32 bytes.

Each block is either a metadata block (has metadata of an object) or data block (has data of an object). Either way, the block starts with the adress of the object it is part. This adress is also the adress of the first block of the object.

This is done because periodic operations to release excessive unused space (freeing pages) often involves moving blocks from one page to another. So, to preserve integrity of references, the object that owns this block will be informed about the new adress of this block.

In case which the block that was moved was the first block, not only the references inside this object will change, but also all the other objects that reference this one will be notified (because they reference the first block of this object, which changed to another location).

# Pages

# Primordials

There are an page, an object and a block wich are primordials, once they are created and untill the program exits or untilt it finishes the zunasm management.

When the procedure [zunasm_start] is called, these primordials are created: the primordial object, being the topmost referencial of the program, and the primordial block that contains it, located in the primordial page previously allocated from the operating system.

The adress of the primordial page is kept, and periodicaly used to group unused memory into some page and releasing it back to the system when it is entirely unused.
