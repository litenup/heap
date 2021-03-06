require 'json'

class Heap
  module ViewHelpers
    def heap_analytics(properties = {})
      config = properties.map {|k,v| "#{k}: #{v}"}.join(", ") if properties.is_a? Hash
      heap_js_block %Q{
        window.heap=window.heap||[],heap.load=function(e,t){window.heap.appid=e,window.heap.config=t=t||{};var r=t.forceSSL||"https:"===document.location.protocol,a=document.createElement("script");a.type="text/javascript",a.async=!0,a.src=(r?"https:":"http:")+"//cdn.heapanalytics.com/js/heap-"+e+".js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(a,n);for(var o=function(e){return function(){heap.push([e].concat(Array.prototype.slice.call(arguments,0)))}},p=["addEventProperties","addUserProperties","clearEventProperties","identify","removeEventProperty","setEventProperties","track","unsetEventProperty"],c=0;c<p.length;c++)heap[p[c]]=o(p[c])};
        heap.load("#{Heap.app_id}", {#{config}});
      }
    end

    def heap_identify(handle, properties = nil)
      body = properties.map {|k,v| "#{k}: \"#{v}\", "}.join.chomp(", ") if properties.is_a? Hash
      heap_js_block %Q{
        heap.identify('#{handle}');
        heap.addUserProperties({#{body}});
      }
    end

    def heap_add_event_properties(properties = {})
      heap_js_block %Q{heap.addEventProperties(#{properties.to_json});}
    end

    def heap_js_block(content)
      return '' unless Rails.application.secrets.heap_id
      javascript_tag :type => "text/javascript" do
        raw content.html_safe
      end
    end
  end
end
