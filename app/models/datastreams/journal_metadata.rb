class JournalMetadata < ActiveFedora::OmDatastream
    set_terminology do |t|
        t.root(path: "journal")
        t.id(:path=>{:attribute=>"id"}, index_as: :stored_searchable)
        t.title(index_as: :stored_searchable)
        t.title_alternative(index_as: :stored_searchable)
        t.issn(index_as: :stored_searchable)
        t.publisher(index_as: :stored_searchable)
        t.physical_location {
            t.place(index_as: :stored_searchable)
            t.years(index_as: :stored_searchable)
            t.note(index_as: :stored_searchable)
        }
    end

    def self.xml_template
        Nokogiri::XML.parse("<journal/>")
    end

    def prefix
        # set a datastream prefix if you need to namespace terms that might occur in multiple data streams 
        ""
    end
end
