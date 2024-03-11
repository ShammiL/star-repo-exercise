import ballerina/http;
import ballerina/io;

string googleSheetServiceUrl = "http://localhost:9092";
string googleSheetAddEndpoint = "/students/star";

public type StarRecord record {|
    string ID;
    string name;
    int starredRepoCount;
|};

http:Client cl = check new (googleSheetServiceUrl);
function writeStudentDetails(StarRecord starRecord) returns error? {
    http:Response res = check cl->post(googleSheetAddEndpoint, starRecord);
    if (res.statusCode == 200) {
        io:println("Congratulations! Your have completed the exercise.");
    } else {
        io:println("Starring repos was not sucessful, please try again.");
    }
}
