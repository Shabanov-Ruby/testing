
5.times do |i|
  user = User.create!(
    email: "user#{i}@example.com",
    password: "123456",
    password_confirmation: "123456"
  )
  puts "Создан пользователь: #{user.email}"
end

User.all.each do |user|
  3.times do |j|
    post = user.posts.create!(
      content: "Это контент поста #{j + 1} пользователя #{user.email}"
    )
    puts "Создан пост: #{post.content} (пользователь: #{user.email})"
    
    2.times do |k|
      comment = post.comments.create!(
        content: "Это комментарий #{k + 1} к посту #{post.id}",
        user: User.order("RANDOM()").first
      )
      puts "Создан комментарий: #{comment.content} (пост: #{post.id})"
    end
  end
end

User.all.each do |follower|
  User.where.not(id: follower.id).each do |followed|
    Follow.create!(follower: follower, user: followed)
    puts "#{follower.email} подписался на #{followed.email}"
  end
end

puts "Сидирование завершено."
