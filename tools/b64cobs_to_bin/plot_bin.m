%% loading
data = convert_bin('C:\Users\reichler\data\Neurofeedback\m400060\2021_08_22\20210822-201113_062.b64');
n_packets = length(data);

t = linspace(0, n_packets/1000, n_packets);
analog = reshape(vertcat(data.analog), [8 n_packets]);
states = reshape(vertcat(data.states), [8 n_packets]);
din = reshape(vertcat(data.digital_in), [16 n_packets]);
dout = reshape(vertcat(data.digital_out), [8 n_packets]);

clear data; % save on mem?

%% plotting stuffs
colors = jet(8);

% analog
subplot(4, 1, 1);
hold on;
for i = 1:8
    plot(t, analog(i, :), 'Color', colors(i, :));
end
ylim([0 4096]);
xlim([t(1) t(end)]);

% states
subplot(4, 1, 2);
hold on;
for i = 1:8
    plot(t, states(i, :), 'Color', colors(i, :));
end
ylim([0 4096]);
xlim([t(1) t(end)]);

% digital out
subplot(4, 1, 4);
hold on;
for i = 1:8
    plot(t, dout(i, :), 'Color', colors(i, :));
end
ylim([0 1]);
xlim([t(1) t(end)]);

% digital in
subplot(4, 1, 3);
colors = jet(16);
hold on;
for i = 1:16
    plot(t, din(i, :), 'Color', colors(i, :));
end
ylim([0 1]);
xlim([t(1) t(end)]);