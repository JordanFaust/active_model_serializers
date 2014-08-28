require 'test_helper'

module ActiveModel
  class Serializer
    class Adapter
      class JsonApiTest < Minitest::Test
        def setup
          @post = ::Model.new(title: 'New Post', body: 'Body')
          @first_comment = ::Model.new(id: 1, body: 'ZOMG A COMMENT')
          @second_comment = ::Model.new(id: 2, body: 'ZOMG ANOTHER COMMENT')
          @post.comments = [@first_comment, @second_comment]
          @first_comment.post = @post
          @second_comment.post = @post

          @post_serializer_class = def_serializer do
            attributes :title, :body
            has_many :comments
          end

          @post_serializer = @post_serializer_class.new(@post)
          @adapter = ActiveModel::Serializer::Adapter::JsonApiAdapter.new(@post_serializer)
        end

        def test_includes_comment_ids
          assert_equal(['1', '2'], @adapter.serializable_hash[:comments])
        end
      end
    end
  end
end
