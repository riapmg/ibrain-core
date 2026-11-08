# frozen_string_literal: true

require "minitest/autorun"
require "securerandom"
require_relative "../app/models/concerns/ibrain/user_api_authentication"

class IbrainUserApiAuthenticationTest < Minitest::Test
  class User
    include Ibrain::UserApiAuthentication

    attr_accessor :ibrain_api_key
    attr_reader :saved

    def initialize(api_key = nil)
      @ibrain_api_key = api_key
      @saved = false
    end

    def save!
      @saved = true
    end
  end

  def test_generate_api_key_uses_48_lowercase_hex_characters
    user = User.new

    key = user.generate_ibrain_api_key

    assert_equal 48, key.length
    assert_match(/\A[0-9a-f]{48}\z/, key)
    assert_equal key, user.ibrain_api_key
    refute user.saved
  end

  def test_generate_api_key_bang_persists_the_new_key
    user = User.new

    user.generate_ibrain_api_key!

    assert_match(/\A[0-9a-f]{48}\z/, user.ibrain_api_key)
    assert user.saved
  end

  def test_clear_api_key_does_not_persist_without_bang
    user = User.new("a" * 48)

    user.clear_ibrain_api_key

    assert_nil user.ibrain_api_key
    refute user.saved
  end

  def test_clear_api_key_bang_persists_the_clear
    user = User.new("a" * 48)

    user.clear_ibrain_api_key!

    assert_nil user.ibrain_api_key
    assert user.saved
  end
end
