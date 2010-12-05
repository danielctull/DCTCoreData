# DCTCoreData

DCTCoreData is my collection of extensions to Apple's Core Data framework. 

## Features

* Convenience methods for fetching from the managed object context
* Automated creation of managed objects from an NSDictionary representation
* A category to handle the ordering of related objects
* Asynchronous tasks and fetching with blocks
* Convenience methods for asynchronously fetching from the managed object context

### NSManagedObjectContext (DCTDataFetching)

Fetching from the context the way it always should have been! Lots of methods to ease the pain of fetching objects from a managed object context.

Also includes an easy way to insert a new object. This will likely be moved to a separate category in the future.

### NSManagedObject (DCTAutomatedSetup)

Category to enable a subclass of NSManagedObject to conform to the DCTManagedObjectAutomatedSetup protocol and take a dictionary to generate its values.

There are a number of methods subclasses can implement that will aid the setup process, I talk about these on [my blog post ](http://danieltull.co.uk/blog/2010/09/30/dctcoredata-dctmanagedobjectautomatedsetup/ "DCTCoreData: DCTManagedObjectAutomatedSetup").

### NSManagedObjectContext (DCTAsynchronousTasks)

Adds methods to perform tasks off the main thread using GCD queues.

The first set allow you to pass a block, in which you can access the threaded managed object context, to perform the task in another queue.

The second set allow you to execute a fetch request on another GCD queue, which will call the given block when done with any objects fetched and an error if there is one. This method returns objects managed in the managed object context called on.

### NSManagedObjectContext (DCTAsynchronousDataFetching)

Similar to the DCTDataFetching category on NSManagedObjectContext, but performed using the asynchronous fetch from the DCTAsynchronousTasks category.

## Examples

An example of the automated setup can be found in the app delegate.

## License

Copyright (C) 2010 Daniel Tull. All rights reserved.
 
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
* Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.