module Relaxation
  module Relaxable
    extend ActiveSupport::Concern

    PERMITTED = [:index, :show, :create, :update, :destroy]

    DEFAULT_SCOPE = :current_user

    included do
      class << self
        attr_accessor :filter_whitelist,
                      :create_whitelist,
                      :update_whitelist,
                      :scope_method
      end
    end

    module ClassMethods
      def writable(*attributes)
        creatable(attributes)
        updatable(attributes)
      end

      def filterable(*attributes)
        self.filter_whitelist = attributes
      end

      def creatable(*attributes)
        self.create_whitelist = attributes
      end

      def updatable(*attributes)
        self.update_whitelist = attributes
      end

      def use_scope(scope_method)
        self.scope_method = scope_method
      end

      def relax(options = {})
        self.scope_method ||= DEFAULT_SCOPE

        permit_actions(options).each do |action|
          define_method(action) { send("_#{action}") }
        end
      end

      def permit_actions(options)
        if only = options[:only]
          Array.wrap(only) & PERMITTED
        elsif except = options[:except]
          PERMITTED - Array.wrap(except)
        else
          PERMITTED
        end
      end
    end

    private
    def _index
      render_list(relation.where(filters))
    end

    def _show
      render status: :ok, json: relation.find(params[:id])
    end

    def _create
      render status: :created, json: relation.create!(create_params)
    end

    def _update
      render status: :ok, json: relation.find(params[:id]).tap { |r| r.update!(update_params) }
    end

    def _destroy
      relation.find(params[:id]).destroy
      head :no_content
    end

    def scope
      send(self.class.scope_method)
    end

    def relation
      scope ? scope.send(relation_name) : model_name.constantize
    end

    def relation_name
      scope && scope.class.reflect_on_all_associations(:has_many).find do |association|
        class_name = association.options && association.options[:class_name]
        class_name ||= association.name.to_s.classify
        class_name == model_name
      end.name
    end

    def model_name
      controller_name.classify
    end

    def render_list(list)
      render status: :ok, json: list
    end

    def filters
      params.permit(*self.class.filter_whitelist)
    end

    def create_params
      required_params.permit(*self.class.create_whitelist)
    end

    def update_params
      required_params.permit(*self.class.update_whitelist)
    end

    def required_params
      params.require("#{controller_name.singularize}")
    end
  end
end

if ActionController.const_defined?("API")
  ActionController::API
else
  ActionController::Base
end.send(:include, Relaxation::Relaxable)
