%% load data
clear;

path_to_inputFolder = "../data/";
path_to_inputDataFile = fullfile(path_to_inputFolder, 'readiness_data');
T = readtable(path_to_inputDataFile);


%% Sum theme counts across themes (columns) and publications (rows)

T_themes_data = T(:,17:end);
T_themes_data = T_themes_data.Variables;
T_themes_data_colsum = sum(T_themes_data, 1, "omitnan");
T_themes_data_rowsum = sum(T_themes_data, 2, "omitnan");

%% prep data for plotting

% publication year
all_years = double(T.Year);

[year,~,ic] = unique(all_years);
yearCounts = accumarray(ic,1);
year_yearCounts = [year, yearCounts];
sortingVar = double(year_yearCounts(:,1));
[~, sortingIdx] = sort(sortingVar, 'ascend');
year_yearCounts = year_yearCounts(sortingIdx, :);

% vaccine
all_vaccines = string([T.Vaccine1; T.Vaccine2; T.Vaccine3; T.Vaccine4; T.Vaccine5; T.Vaccine6; T.Vaccine7]);
all_vaccines = all_vaccines(all_vaccines ~= "");
all_vaccines_unique = unique(all_vaccines);
X_piechart_vaccines = categorical(all_vaccines);

% methodology
all_methodologies = string([T.Methodology1; T.Methodology2; T.Methodology3]);
all_methodologies = all_methodologies(all_methodologies ~= "");
[methodology,~,ic] = unique(all_methodologies);
methodologyCounts = accumarray(ic,1);
methodology_methodologyCounts = [methodology, methodologyCounts];
sortingVar = double(methodology_methodologyCounts(:,2));
[~, sortingIdx] = sort(sortingVar, 'ascend');
methodology_methodologyCounts = methodology_methodologyCounts(sortingIdx, :);

bar_data_y = (categorical(methodology_methodologyCounts(:,1)));
bar_data_y_cat = bar_data_y;
bar_data_y_cell = cellstr(bar_data_y);
bar_data_y = reordercats(bar_data_y_cat, bar_data_y_cell);
methodology_y = bar_data_y;
methodology_y_numeric = 1:numel(methodology_y);

methodology_x = double(methodology_methodologyCounts(:,2));

% content
all_contents = string([T.Content1; T.Content2]);
all_contents = all_contents(all_contents ~= "");
[content,~,ic] = unique(all_contents);
contentCounts = accumarray(ic,1);
content_contentCounts = [content, contentCounts];
sortingVar = double(content_contentCounts(:,2));
[~, sortingIdx] = sort(sortingVar, 'ascend');
content_contentCounts = content_contentCounts(sortingIdx, :);

bar_data_y = (categorical(content_contentCounts(:,1)));
bar_data_y_cat = bar_data_y;
bar_data_y_cell = cellstr(bar_data_y);
bar_data_y = reordercats(bar_data_y_cat, bar_data_y_cell);
content_y = bar_data_y;
content_y_numeric = 1:numel(content_y);

content_x = double(content_contentCounts(:,2));

% themes
T_themes = T(:,17:end);
theme_names = string(T_themes.Properties.VariableDescriptions)';
theme_counts = double(sum(table2array(T_themes), "omitnan"))';
[~, idx] = sort(theme_counts);
theme_names = theme_names(idx);
themecount_x = theme_counts(idx);

themecount_y =(1:numel(themecount_x))';


axis_font_size = 12;

%% make plots - fig 2

yearcount_x = year_yearCounts(:,1);
yearcount_y = year_yearCounts(:,2);

figure;

subplot(1,2,1)
bar(yearcount_x, yearcount_y);

for i=1:numel(yearcount_x)
    text(yearcount_x(i), yearcount_y(i)+0.1, num2str(yearcount_y(i)),...
        'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')
end


xticks(min(all_years) : 1 : max(all_years));
xtickangle(90)
ylim([0, (max(year_yearCounts(:,2))+0.75)]);
ylabel('Publication count');
ax = gca;
ax.FontSize = axis_font_size;

explode_vec = ones(length(all_vaccines_unique), 1) * 3;

subplot(1,2,2)
p = pie(X_piechart_vaccines, all_vaccines_unique);

pText = findobj(p,'Type','text');

pText(4).Position(2) = (pText(4).Position(2)) * 1.05; % move Dengue label down a little
pText(17).Position(2) = (pText(17).Position(2)) * 1.05; % move Yellow Fever label up a little

ax = gca;
ax.FontSize = axis_font_size;

fig_size_x = 12;
fig_size_y = 5;

set(gcf,...
    'Units', 'Inches', ...
    'Position', [0, 0, fig_size_x, fig_size_y], ...
    'PaperPositionMode', 'auto');

section_labels_x = [0.07, 0.48];
section_labels_y = 0.98;
section_labels_fontsize = 17;

a = annotation('textbox', [section_labels_x(1), section_labels_y, 0, 0], 'string', 'a.');
a.FontSize = section_labels_fontsize;

a = annotation('textbox', [section_labels_x(2), section_labels_y, 0, 0], 'string', 'b.');
a.FontSize = section_labels_fontsize;

saveas(gcf, 'readiness_figure_2', 'epsc');


%% make plots - fig 3

figure;

subplot(1,2,1)
barh(methodology_y, methodology_x);
for i=1:numel(methodology_x)
    text(methodology_x(i)+1.5, methodology_y_numeric(i) - 0.25, num2str(methodology_x(i)),...
        'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')
end
xlabel('Publication count');
xlim([0, max(methodology_x)+4]);
ax = gca;
ax.FontSize = axis_font_size;



subplot(1,2,2)
barh(content_y, content_x);
for i=1:numel(content_x)
    text(content_x(i)+0.75, content_y_numeric(i) - 0.25, num2str(content_x(i)),...
        'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')
end
xlabel('Publication count');
xlim([0, max(content_x)+2]);
ax = gca;
ax.FontSize = axis_font_size;

fig_size_x = 12;
fig_size_y = 5;

set(gcf,...
    'Units', 'Inches', ...
    'Position', [0, 0, fig_size_x, fig_size_y], ...
    'PaperPositionMode', 'auto');

section_labels_x = [0.02, 0.48];
section_labels_y = 0.98;
section_labels_fontsize = 17;

a = annotation('textbox', [section_labels_x(1), section_labels_y, 0, 0], 'string', 'a.');
a.FontSize = section_labels_fontsize;

a = annotation('textbox', [section_labels_x(2), section_labels_y, 0, 0], 'string', 'b.');
a.FontSize = section_labels_fontsize;

saveas(gcf, 'readiness_figure_3', 'epsc');


%% make plots - fig 4


figure;

barh(themecount_y, themecount_x)
for i=1:numel(themecount_x)
    text(themecount_x(i)+1.5, themecount_y(i) - 0.25, num2str(themecount_x(i)),...
        'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')
end
yticklabels(theme_names)
xlabel('Publication count');
xlim([0, max(themecount_x)+4]);
ax = gca;
ax.FontSize = axis_font_size;

saveas(gcf, 'readiness_figure_4', 'epsc');

