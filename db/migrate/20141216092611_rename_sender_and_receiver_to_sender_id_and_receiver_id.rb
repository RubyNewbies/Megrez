class RenameSenderAndReceiverToSenderIdAndReceiverId < ActiveRecord::Migration
  def change
    rename_column :messages, :receiver, :receiver_id
    rename_column :messages, :sender, :sender_id
  end
end
