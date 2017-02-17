class CourriersLocation < ApplicationRecord
  enum location_type: { Requested: 0,
                        Automatic: 1
              }
end
