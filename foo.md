I'm starting to lock down rel-10.

we added the `list` tool with queue/deque operations (lpush, rpush, lpop, rpop, lpeek, rpeek, list, count).  The intention is that this provides similar the agent a place to build up todo lists and play them out with minimal tool usage.  It's more flexible that Claude Codes able to funciton as FIFO(default) or LIFO.  It also persists across clears so you can build up a work plan in one context and use it in the next.

Bidirectional ik:// to filesystem path translation. WE've talked a few times about this in previous posts.  The idea is that there's this internal file space that's always avaialble to any agent no matter what project or even machine you're running on.  Right now we simply translate the ik:// paths so they map to $IKIGAI

rel-10: Pinned Documents, URI Mapping & List Tool (in progress)
Objective: System prompt assembly, internal URI scheme, and per-agent list management

Features:

/pin and /unpin commands for managing pinned documents
Document cache with ik:// URI support
list tool with deque operations (lpush, rpush, lpop, rpop, lpeek, rpeek, list, count)
UI improvements (braille spinner, flicker elimination)
Complete readline/editline control key support (Ctrl+K kill-to-end, etc.)
