# ShinyCMS Features

## Soft Delete

All ShinyCMS models have soft-delete built-in, with the exception of upvotes.

When you delete an item via the web interface, or via the rails console, it is marked as deleted and no longer returned in results, but the data is still in your database (except for email addresses, which are obfuscated immediately when the record is marked as deleted).

This means that in the event of deleting something that you later wish you hadn't deleted, it is possible to recover it in the console - by using the `.with_deleted` scope to search for it, and the `.recover` method to undelete it.


### More information

Soft delete is powered by the [ActsAsParanoid](https://github.com/ActsAsParanoid/acts_as_paranoid) gem; their docs have more details on how it works and how to recover your data if you need to.
