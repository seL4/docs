= CAmkES 2.1.0 Release Notes =

== New Features ==

> -   runner takes an --architecture command line argument which selects
>     the target architecture. Valid arguments are: aarch32, arm\_hyp,
>     ia32
> -   added the ability to specify a hardware dataport as cached.
>     Previously all hardware dataports were mapped uncached. This
>     feature is intended to be used on dataports backed by DMA-able
>     memory to improve access times. Functions to flush dataports from
>     the cache are also provided.
> -   support for seL4 3.0.0

== Removed Features ==

> -   --hyp command line argument is replaced with
>     --architecture arm\_hyp

== API Removals ==

=== Unmarshalling Helpers === These were intended for use in templates,
but are no longer used in any internal templates: \* camkes\_marshal \*
camkes\_marshal\_string \* camkes\_unmarshal \*
camkes\_unmarshal\_string

=== DMA Utilities === These had been deprecated for a long period and
are now being removed: \* camkes\_dma\_page\_alloc \*
camkes\_dma\_page\_free
