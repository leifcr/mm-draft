# MongoMapper Draft plugin
[![Build Status](https://travis-ci.org/leifcr/mm-draft.svg?branch=master)](https://travis-ci.org/leifcr/mm-draft) [![Coverage Status](https://coveralls.io/repos/leifcr/mm-draft/badge.png)](https://coveralls.io/r/leifcr/mm-draft) [![Dependency Status](https://gemnasium.com/leifcr/mm-draft.svg)](https://gemnasium.com/leifcr/mm-draft)


Plugin for MongoMapper to have draft/published option on models.

NOTE: Can have issues with other plugins...

##Instance methods
<pre>
.draft?           - true/false
.published?       - true/false
.published_record - returns the published record) (or nil, if the document never has been published)
.draft_record     - returns the draft record for a published record
</pre>

*draft_record* will return self if the draft? returns true
*published_record* will return self if draft? returns false

## Usage:
Create record as normal.

*.save* - Saves draft (with normal validation)

*.publish* - Saves the current record as draft, creates a new published record (returns true/false, depending on validation of draft record)

Validation is skipped on the published record, as the draft record should be checked for validations when saving.

All records will be duplicated (draft + published) in the DB instead of beeing embedded documents, as embedding would limit the size to half of what MongoDB is capable of.

Duplicating the records also gives the benefit of working directly on the published record. (although this isn't recommended, as it kind of breaks the draft/published structure)

## Example

### Model
<pre>
class Monkey
  include MongoMapper::Document
  plugin MongoMapper::Draft

  key :name, String, :default => "test"
end
</pre>
### Usage of model
<pre>
m = Monkey.new
m.name = "Leif"
m.save

m.is_published? (will return false)
m.publish (will return true/false)

m.name = "Artn"
m.save

m.name # returns "Artn"

m.published_model.name # returns "Leif"
</pre>


Copyright (c) 2011 Leif Ringstad, released under the MIT license
