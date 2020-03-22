struct Packlink
  struct Callback < Base
    will_create "shipments/callback"

    def self.register(url : String)
      create({url: url})
    end

    struct Event
      JSON.mapping({
        name:     {key: "event", type: String},
        datetime: String,
        data:     Data,
      })

      def created_at
        Time.parse_utc(datetime, "%F %T")
      end

      struct Data
        JSON.mapping({
          shipment_custom_reference: String,
          shipment_reference:        String,
        })
      end
    end
  end
end
