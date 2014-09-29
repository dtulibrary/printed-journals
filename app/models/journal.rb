class Journal < ActiveFedora::Base
    has_metadata 'descMetadata', type: JournalMetadata

    has_attributes :id, datastream: 'descMetadata', multiple: false
    has_attributes :title, datastream: 'descMetadata', multiple: false
    has_attributes :title_alternative, datastream: 'descMetadata', multiple: true
    has_attributes :issn, datastream: 'descMetadata', multiple: true
    has_attributes :publisher, datastream: 'descMetadata', multiple: true

#   delegate :title_alternative, :to=>'descMetadata'
#   delegate :issn,              :to=>'descMetadata'
#   delegate :publisher,         :to=>'descMetadata'
    delegate :physical_location, :to=>'descMetadata'
    delegate :z30, :to=>'descMetadata'
end
