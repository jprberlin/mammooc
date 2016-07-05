# frozen_string_literal: true

require 'devise_helper'

module Users
  class RegistrationsController < Devise::RegistrationsController
    def new
      super
    end

    def create
      flash['error'] ||= []
      exception = ''
      full_user_params = sign_up_params
      build_resource(full_user_params)
      begin
        resource.save
      rescue ActiveRecord::RecordInvalid => error
        exception += error.to_s
      end

      yield resource if block_given?
      if resource.persisted? && exception.blank?
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
          session.delete(:user_original_url)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        session_infos = {}
        session_infos['first_name'] = sign_up_params[:first_name] || (session[:resource].present? ? session[:resource]['first_name'] : nil)
        session_infos['last_name'] = sign_up_params[:last_name] || (session[:resource].present? ? session[:resource]['last_name'] : nil)
        session_infos['primary_email'] = sign_up_params[:primary_email] || (session[:resource].present? ? session[:resource]['primary_email'] : nil)
        session[:resource] = session_infos
        begin
          resource.destroy
          UserEmail.destroy_all(user_id: nil)
        rescue ActiveRecord::RecordInvalid => error
          exception += error.to_s
        end
        resource.errors.each do |key, value|
          flash['error'] << "#{t('users.sign_in_up.' + key.to_s)} #{value}"
        end
        redirect_to new_user_registration_path
      end

      return unless exception.present?
      if exception.to_s.include?(t('errors.messages.invalid'))
        flash['error'] << t('devise.registrations.email.invalid')
      elsif exception.to_s.include?(t('flash.error.taken'))
        flash['error'] << t('devise.registrations.email.taken')
      end
    end

    # GET /users/finish_signup
    def finish_signup
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    end

    def update(redirection_success = "#{user_settings_path(current_user.id)}?subsite=account",
      redirection_failure = "#{user_settings_path(current_user.id)}?subsite=account")

      if current_user.primary_email_autogenerated? || current_user.first_name_autogenerated? || current_user.last_name_autogenerated?
        redirection_success = dashboard_path
        redirection_failure = finish_signup_path
      end

      flash['error'] ||= []
      exception = ''
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      begin
        resource_updated = update_resource(resource, update_params)
      rescue ActiveRecord::RecordInvalid => error
        exception += error.to_s
      end

      yield resource if block_given?
      if resource_updated && exception.blank? && flash['error'].blank?
        if is_flashing_format?
          flash_key = if update_needs_confirmation?(resource, prev_unconfirmed_email)
                        :update_needs_confirmation
                      else
                        :updated
                      end
          set_flash_message :notice, flash_key
        end
        bypass_sign_in resource_name, resource
        redirect_to redirection_success, notice: t('flash.notice.users.successfully_updated')
      else
        session_infos = {}
        session_infos['first_name'] = update_params[:first_name]
        session_infos['first_name'] = resource.first_name unless session_infos['first_name'].present? || resource.first_name_autogenerated?
        session_infos['last_name'] = update_params[:last_name]
        session_infos['last_name'] = resource.last_name unless session_infos['last_name'].present? || resource.last_name_autogenerated?
        session_infos['primary_email'] = update_params[:primary_email]
        session_infos['primary_email'] = resource.primary_email unless session_infos['primary_email'].present? || resource.primary_email_autogenerated?
        session[:resource] = session_infos
        resource.errors.each do |key, value|
          flash['error'] << "#{t('users.sign_in_up.' + key.to_s)} #{value}"
        end
        if exception.present? && exception.to_s.include?(t('errors.messages.invalid'))
          flash['error'] << t('devise.registrations.email.invalid')
        elsif exception.present? && exception.to_s.include?(t('activerecord.errors.messages.taken'))
          flash['error'] << t('devise.registrations.email.taken')
        end
        redirect_to redirection_failure
      end
    end

    def update_resource(resource, params)
      if !resource.password_autogenerated
        super
      elsif params[:password].blank? && params[:password_confirmation].blank?
        params.delete(:password)
        params.delete(:password_confirmation)
        resource.update(params)
      else
        return false unless resource.update(params)
        resource.password_autogenerated = false
        resource.save!
        true
      end
    end

    def destroy
      if resource.destroy
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        set_flash_message :notice, :destroyed if is_flashing_format?
        yield resource if block_given?
        respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
      else
        flash['error'] ||= []
        flash['error'] << t('users.settings.still_admin_in_group_error').to_s
        redirect_to "#{user_settings_path(current_user.id)}?subsite=account"
      end
    end

    protected

    def after_sign_up_path_for(resource)
      after_sign_in_path_for(resource)
    end

    def after_update_path_for(resource)
      after_sign_in_path_for(resource)
    end

    private

    def sign_up_params
      params.require(:user).permit(:first_name, :last_name, :primary_email, :password, :password_confirmation)
    end

    def update_params
      params.require(:user).permit(:first_name, :last_name, :primary_email, :password, :password_confirmation, :current_password)
    end

    def add_resource
      @resource = session[:resource]
    end
  end
end
