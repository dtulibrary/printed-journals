# Generated via
#  `rails generate worthwhile:work Journals`
class Journal < ActiveFedora::Base
  include DtuCurationConcern

# Single-value fields
# has_attributes :title, :datastream: :descMetadata, multiple: false
# has_attributes :title_alternative, :title_previous, :title_next, :organisation, :issn, datastream: :descMetadata, multiple: true
end
