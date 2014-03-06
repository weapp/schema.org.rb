schema.org.rb
=============

Parser for schema.org

Execute `ruby parser.rb` for view an example of a random model.

```
Thing>Action>TransferAction
- additionalType
- alternateName
- description
- image
- name
- sameAs
- url
- agent
- endTime
- instrument
- location
- object
- participant
- result
- startTime
- fromLocation
- toLocation


TransferAction
============================================================

Thing
------------------------------------------------------------
additionalType                 URL
alternateName                  Text
description                    Text
image                          URL
name                           Text
sameAs                         URL
url                            URL

Action
------------------------------------------------------------
agent                          Organization | Person
endTime                        DateTime
instrument                     Thing
location                       Place | PostalAddress
object                         Thing
participant                    Organization | Person
result                         Thing
startTime                      DateTime

TransferAction
------------------------------------------------------------
fromLocation                   Number | Place
toLocation                     Number | Place
```
