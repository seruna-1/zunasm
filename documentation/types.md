# Primordial

No bytes to indicate type, since this is a unique object.

Only one sequence of data: references.

# Referencer

8 bytes for its type: 1.

Sequences of data:

 - Adresses of objects that reference this one

 - References

# Bytes

8 bytes for its type: 2.

Sequences of data:

 - Adresses of objects that reference this one

 - Bytes

# Names

8 bytes for its type: 3.

Only one sequence of data, encodided as utf8, representing the names separated by a null character.

The first block parent adress, instead of 0, is the adress of the object where these names happen to be. This is fine, since they can be in only one place.
