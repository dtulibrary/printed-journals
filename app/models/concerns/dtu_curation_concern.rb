module DtuCurationConcern
  extend ActiveSupport::Concern

  included do
    include ::CurationConcern::Work
    include ::WithJournalMetadata
    # This catches the fields that are used by default in Worthwhile
    # as we express those fields in journal metadata or remove the fields from Create/Edit forms, we can remove them from here
    # and eventually remove the WithWorthwhiledMetadata module (and corresponding datastream) entirely.
    include ::WithWorthwhileMetadata
  end
end
