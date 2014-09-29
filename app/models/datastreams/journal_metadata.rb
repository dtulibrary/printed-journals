class JournalMetadata < ActiveFedora::OmDatastream
    set_terminology do |t|
        t.root(path: "journal")
        t.id(:path=>{:attribute=>"id"}, index_as: :stored_searchable)
        t.title(index_as: :stored_searchable)
        t.title_alternative(index_as: :stored_searchable)
        t.title_previous(index_as: :stored_searchable)
        t.title_next(index_as: :stored_searchable)
        t.organisation(index_as: :stored_searchable)
        t.issn(index_as: :stored_searchable)
        t.coden(index_as: :stored_searchable)
        t.publisher(index_as: :stored_searchable)
        t.note(index_as: :stored_searchable)
        t.holdings(index_as: :stored_searchable)
        t.physical_location {
            t.place(index_as: :stored_searchable)
            t.years(index_as: :stored_searchable)
            t.note(index_as: :stored_searchable)
        }
        t.z30 {
            t.sub_library(index_as: :stored_searchable)
            t.collection(index_as: :stored_searchable)
            t.shelf_code(index_as: :stored_searchable)
            t.shelf_code2(index_as: :stored_searchable)
            t.barcode(index_as: :stored_searchable)
            t.open_date(index_as: :stored_searchable)
            t.year(index_as: :stored_searchable)
            t.volume(index_as: :stored_searchable)
            t.issue(index_as: :stored_searchable)
            t.part(index_as: :stored_searchable)
            t.pages(index_as: :stored_searchable)
            t.status(index_as: :stored_searchable)
            t.order_number(index_as: :stored_searchable)
            t.description(index_as: :stored_searchable)
            t.issue_date(index_as: :stored_searchable)
            t.expected_date(index_as: :stored_searchable)
            t.arrival_date(index_as: :stored_searchable)
            t.type(index_as: :stored_searchable)
            t.process_status(index_as: :stored_searchable)
            t.price(index_as: :stored_searchable)
            t.loans(index_as: :stored_searchable)
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
