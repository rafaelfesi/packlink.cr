struct Packlink
  struct Proxy
    getter client : Client

    def initialize(@client : Client)
    end

    {% begin %}
      {% resources = {
           callback: {"register"},
           customs:  {"pdf"},
           draft:    {"create"},
           dropoff:  {"all"},
           label:    {"all"},
           order:    {"create"},
           service:  {"find", "from", "to", "package"},
           shipment: {"find"},
           tracking: {"history"},
         } %}

      {% for resource, methods in resources %}
        {% resource_class = resource.camelcase %}

        struct {{ resource_class.id }}
          getter client : Client

          def initialize(@client : Client)
          end

          {% for method in methods %}
            def {{ method.id }}(*args)
              Packlink::{{ resource_class.id }}.{{ method.id }}(*args, client: @client)
            end
          {% end %}
        end

        def {{ resource.id }}
          Packlink::Proxy::{{ resource_class.id }}.new(@client)
        end
      {% end %}
    {% end %}
  end
end
