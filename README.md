# partitions
Some procedures for the generation of partitions:
- A procedure that returns a list of all partitions.
- A procedure that returns a stream of all partitions.
- A procedure that returns a sequence of partitions.

The procedures use hashes in order to avoid repetition of identical computations.
For every procedure there are two versions:
- one that uses an internal hash that is lost after completion of the procedure/stream/sequence.
- another one that preserves the hash between successive calls.
