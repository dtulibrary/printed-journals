class Journal < ActiveFedora::Base
    has_metadata 'descMetadata', type: JournalMetadata

    has_attributes :id, datastream: 'descMetadata', multiple: false
    has_attributes :title, datastream: 'descMetadata', multiple: false
    has_attributes :title_alternative, datastream: 'descMetadata', multiple: true
    has_attributes :title_previous, datastream: 'descMetadata', multiple: true
    has_attributes :title_next, datastream: 'descMetadata', multiple: true
    has_attributes :organisation, datastream: 'descMetadata', multiple: true
    has_attributes :issn, datastream: 'descMetadata', multiple: true
    has_attributes :coden, datastream: 'descMetadata', multiple: true
    has_attributes :publisher, datastream: 'descMetadata', multiple: true
    has_attributes :note, datastream: 'descMetadata', multiple: true
    has_attributes :holdings, datastream: 'descMetadata', multiple: true

    delegate :physical_location, :to=>'descMetadata'
    delegate :z30, :to=>'descMetadata'
end
