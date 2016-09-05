class User < ApplicationRecord
  PROTECTED_FIELDS = %w(oauth_token oauth_expires_at uid provider)

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider         = auth.provider
      user.uid              = auth.uid
      user.name             = auth.info.name
      user.email            = auth.info.email
      user.avatar_url       = auth.info.image
      user.oauth_token      = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)

      user.save!
    end
  end

  def instructor_for?(course)
    true
  end

  def as_json(options = {})
    super(options.merge({
      except: User::PROTECTED_FIELDS
    }))
  end
end
