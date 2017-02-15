1. Create a new directory ``my-project``.
2. Clone the contents of this folder (``git-push-templates/php-codeigniter``) into your project folder. (Don't copy the .git folder).
3. Create a git push enabled service on Hasura.
4. Set Environment Variable ``CI_ENV`` to production.
5. Create a git repo inside ``my-project`` by running a ``git init``.
6. Add the git remote called hasura as directed, and run a ``git push hasura master`` to deploy your code on your Hasura project.
