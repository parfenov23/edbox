class SlackNotify
	def self.channel
		"https://hooks.slack.com/services/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"
	end

	def self.send(message)
		::Thread.new{
			notifier = Slack::Notifier.new channel
			notifier.ping message
		}
	end
end