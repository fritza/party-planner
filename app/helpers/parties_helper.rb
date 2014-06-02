require 'builder'

module PartiesHelper
  
  class NameSplitter
    def initialize(args = nil)
      @params = args    # TODO: Work out some defaults
      @shared_builder = Builder::XmlMarkup.new
    end
    
    def clear
      @shared_builder = Builder::XmlMarkup.new
    end
  
    def split_name(a_name = nil)
      return nil if ! a_name
      parts = a_name.split(/\s/)
      return nil if ! parts || parts.count == 0
    
      a_name = a_name.strip
    
      first_part = parts[0...-1].join ' '
      [first_part, parts[-1]]
    end
  
    def markup_for(a_name = nil, extra='')
      return nil if ! a_name
    
      parts = self.split_name(a_name)
    
      b = @shared_builder
    
      if @params
        div_params = @params[:div_params]
        given_params = @params[:given_params]
        surname_params = @params[:surname_params]
      end
    
      b.div(div_params) do | div |
        b.text! extra if extra != ''
        if parts[0] != ""
          sp = b.span(given_params) {
            b.text! parts[0] + " "
          }
          puts sp
        end
        b.span(surname_params) {
          b.text! parts[1] 
        }
      end
      retval = b.target!
    end # markup_for 
  
  end #  class NameSplitter
  
  $shared_splitter = NameSplitter.new div_params: { id: 'form-header' },
                                      given_params: { id: 'first-name'},
                                      surname_params: { id: 'last-name' }
  
  
  def name_markup(a_name, extra='')
    $shared_splitter.clear
    $shared_splitter.markup_for(a_name, extra).html_safe
  end
  
end
