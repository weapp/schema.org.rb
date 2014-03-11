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
The act of transferring/moving (abstract or concrete) animate or inanimate objects from one place to another.
============================================================
Thing > Action > TransferAction

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

# transfer_action.rb
class TransferAction < Action
  attribute :from_location
  attribute :to_location
end

# action.rb
class Action < Thing
  attribute :agent
  attribute :end_time
  attribute :instrument
  attribute :location
  attribute :object
  attribute :participant
  attribute :result
  attribute :start_time
end

# thing.rb
class Thing
  include ActiveAttr::Attributes

  attribute :additional_type
  attribute :alternate_name
  attribute :description
  attribute :image
  attribute :name
  attribute :same_as
  attribute :url
end
```
