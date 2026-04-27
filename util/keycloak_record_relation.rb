# Class for Keycloak models to allow custom logic for the record collection

class KeycloakRecordRelation < Array
  def to_h
    map { |el| el.respond_to?(:to_h) ? el.to_h : el }
  end
end