require 'case'
class LeaveCommentTest < Case

  def setup
    super
    @params = {
      "writing"  => "relational-basics-2",
      "nickname" => "the sender's nickname",
      "comment"  => "the sender's comment", 
      "mail"     => "sender@mail.com"
    }
  end
  
  def teardown
    Mail::TestMailer.deliveries.clear
  end

  def test_empty_request
    post '/leave-comment'
    assert_equal 400, status, "/leave-comment without params returns 400"
  end
  
  def test_valid_request
    post "/leave-comment", @params
    assert_equal 200, status, "/leave-comment succeeds when everything is passed"
    assert (mail = Mail::TestMailer.deliveries.first) != nil
    assert_equal ["sender@mail.com"], mail.from
    assert_equal ["blambeau@gmail.com"], mail.to
    assert_equal "the sender's comment", mail.body.to_s
    assert_equal "[revision-zero.org] Comment from the sender's nickname (relational-basics-2)", mail.subject
  end
  
  def test_when_mail_is_missing
    @params.delete("mail")
    post "/leave-comment", @params
    assert_equal 200, status, "/leave-comment succeeds even if the mail is missing"
    assert (mail = Mail::TestMailer.deliveries.first) != nil
    assert_equal ["info@revision-zero.org"], mail.from
  end
  
  def test_when_nickname_is_missing
    @params.delete("nickname")
    post "/leave-comment", @params
    assert_equal 400, status, "/leave-comment without nickname returns 400"
  end

  def test_when_comment_is_missing
    @params.delete("comment")
    post "/leave-comment", @params
    assert_equal 400, status, "/leave-comment without comment returns 400"
  end

end
