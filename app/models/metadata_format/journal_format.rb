# This is required by the OAI Provider in order to support encoding journal documents
class JournalFormat < OAI::Provider::Metadata::Format

  def initialize
    @prefix = 'mods'
    @schema = ''
    @namespace = 'http://www.loc.gov/mods/v3'
    @element_namespace = ''
    @fields = []
  end

  def encode(model, record)
    record.export_as_journal_xml
  end

  def header_specification
    {}
  end

end
