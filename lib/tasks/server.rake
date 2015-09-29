namespace :server do
  desc "Deploy"
  task deploy: :environment do
    projects = {"1" => {name: "beta", rep: "master"}, "2" => {name: "release", rep: "release"}}
    p "Выберете проект:"
    projects.map do |k, v|
      p "#{k}) #{v[:name]}"
    end
    num = STDIN.gets.chomp
    current_project = projects[num]
    p "Выбран проект #{current_project[:name]}"
    p "Введите имя коммита:"
    commit = STDIN.gets.chomp

    p "Обновляю репозиторий"
    sh 'git add .'
    sh "git commit -m '#{commit}'"

    valid = true
    pull_log = p `git pull origin #{current_project[:rep]}`

    valid = false if pull_log.scan("CONFLICT").present?
    if valid
      pull_log = p `git pull origin master` if current_project[:name] == "release"
      valid = false if pull_log.scan("CONFLICT").present?
      if valid
        sh "git push origin #{current_project[:rep]}"
        p "Запускаю деплой!"
        sh "cap #{current_project[:name]} deploy"
      end
    end
  end

end
