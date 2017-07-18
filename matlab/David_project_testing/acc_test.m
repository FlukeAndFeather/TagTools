function detections_acc = acc_test(detections, events, fs)
% Determines the number of hits, misses, and false alarms between
%   automatically detected events from tagtools (i.e. find_peak.m) and
%   known event occurences from manual determination methods. This is
%   useful for plotting ROC curves.
%
% INPUTS:
%   detections = A vector containing the times (indices from start of tag
%       recording) at which an automatically detected event was determined
%       to have taken place.
%   events = A vector containing the known times (indices from start of tag
%       recording) at which an event was known to have taken place from
%       manual determination methods or a matrix/cell array containing the
%       start and end times of a known event.
%   fs = The sampling rate in Hz of the detections and events data.
%
% OUTPUTS:
%   detection_acc = A structure containing the number of hits, misses, and
%       false alarms found between the detection and events inputs. A hit
%       constitutes a correct detection of an event. A miss constitutes an
%       event that was not detected. A false alarm constitues an incorrect
%       detection of a nonexistant event.

if nargin < 2
    help acc_test
end

if iscell(events)
    ke = [];
    for i = 1:size(events, 1)
        ke = [ke; events{i}(:,2:3)];
    end
    events = table2array(ke);
end

if size(events, 2) > 1
    count_hits = 0;
    count_false_alarms = 0;
    for j = 1:length(detections)
        detend = detections(j) <= events(:, 2);
        detstart = detections(j) >= events(:, 1);
        det = detend == detstart;
        if sum(det(1:end)) == 1
            count_hits = count_hits + 1;
        elseif sum(det(1:end)) == 0
            count_false_alarms = count_false_alarms + 1;
        end
    end
    count_misses = size(events, 1) - count_hits;
end

if size(events, 2) == 1
    count_hits = 0;
    count_false_alarms = 0;
    for j = 1:length(detections)
        detplus = detections(j) <= (events + (10 * fs));
        detminus = detections(j) >= (events - (10 * fs));
        det = detplus == detminus;
        if sum(det(1:end)) == 1
            count_hits = count_hits + 1;
        elseif sum(det(1:end)) == 0
            count_false_alarms = count_false_alarms + 1;
        end
    end
    count_misses = size(events, 1) - count_hits;
end

%create structure of count_hits, count_false_alarms, and count_misses
field1 = 'count_hits';  value1 = count_hits;
field2 = 'count_false_alarms';  value2 = count_false_alarms;
field3 = 'count_misses';  value3 = count_misses;
detections_acc = struct(field1,value1,field2,value2,field3,value3);

end