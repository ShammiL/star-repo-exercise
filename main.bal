import ballerinax/github;
import ballerina/io;

// -------------------------
//        Task 1
// -------------------------
// 1. Enter your name and university ID here.
// eg: studentName = "John Doe" , studentId = "180311AU"
string studentName = "";
string studentId = "";

// -------------------------
//        Task 2
// -------------------------
// 1. Enter your GitHub personal access token(classic) here.
// HINT: If you don't have a token obtained, obtain a GitHub personal access token with repo access using the guidelines in
// https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token
string githubToken = "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";

int starredRepoCount = 0;
string orgName = "ballerina-platform";

public function main() returns error? {
    final github:Client ghClient = check new ({auth: {token: githubToken}});

    // -------------------------
    //        Task 3
    // -------------------------
    // 1. Get all the repositories of the organization using the getRepositories() function of the ghClient.
    // HINT: https://lib.ballerina.io/ballerinax/github/4.6.0#Client-getRepositories
    // getRepositories() function accepts two parameters, "owner" and "isOrganization" to which you must pass the "orgName" declared above and "true" respectively.
    // The return type of the function is stream<github:Repository, github:Error?>, you should assign the returned value of the function call to a variable named "repos" of this type.
    stream<github:Repository, github:Error?> repos = check ghClient->getRepositories(orgName, true);

    check repos.forEach(function(github:Repository repo) {
        string repoName = repo.name;
        string owner = repo.owner.login;

        // -------------------------
        //        Task 4
        // -------------------------
        // 1. Star each repository using the starRepository() function of the ghClient.
        // HINT: https://lib.ballerina.io/ballerinax/github/4.6.0#Client-starRepository
        // starRepository() function accepts two parameters, "owner" and "repositoryName" to which you must pass the "orgName" and "repoName" variables respectively.
        github:Error? starRepository = ghClient->starRepository(owner, repoName);

        if (starRepository is github:Error) {
            io:println("Error occurred while starring the repo : " + repoName + " " + starRepository.message());
            return;
        }
        io:println(string `${repoName} repository starred.`);
        starredRepoCount = starredRepoCount + 1;
    });
    io:println(string `Finished processing the ${orgName} organization with ${starredRepoCount} repositories starred`);

    check writeStudentDetails({ID: studentId, name: studentName, starredRepoCount});
}
