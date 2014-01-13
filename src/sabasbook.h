#ifndef SABASBOOK_H
#define SABASBOOK_H

#include <QObject>

//#define SAVE_PLAYLIST
class QMediaPlaylist;
class QMediaPlayer;
class SabasBook : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(QString coverPath READ coverPath NOTIFY coverPathChanged)

public:
    explicit SabasBook(const QString &folder, QObject *parent = 0);
    ~SabasBook();

    void setName(const QString &name);
    QString name() const;

    qint64 lastTrackPosition() const;

    QString rootPath() const;
    void setRootPath(const QString &rootPath);

    QMediaPlaylist *playlist() const;
#ifdef SAVE_PLAYLIST
    QStringList playListStrings() const;
    void setPlaylist(const QStringList &tracks);
#endif
    int currentIndex() const;
    void setCurrentIndex(int index);
    QString coverPath() const;

    int lastIndex() const;
    void setLastIndex(int lastIndex);
    Q_INVOKABLE int mediaCount() const;
    Q_INVOKABLE QString mediaToDisplayStringAt(int index) const;
    void setPlaybackRate(qreal rate);
    qreal playbackRate() const;
    void emitVissibleDataChangedSignals(); //dirty hack to update qml listview

public slots:
    bool locateMedia();
    bool relocateMedia();
    void setLastTrackPosition(qint64 position);
    void next();
    void previous();
    void setCoverPath(QString path);

signals:
    void nameChanged(const QString &name);
    void trackPositionChanged(qint64 position);
    void trackDurationChanged(qint64 position);
    void currentIndexChanged(int index);
    void coverPathChanged(QString path);

private:
    void scanFolder(const QString &folder);
    QMediaPlaylist *m_playlist;
    QString m_name;
    QString m_rootPath;
    int m_currentIndex;
    int m_lastIndex;
    qint64 m_lastTrackPosition;
    QString m_coverPath;
    qreal m_playbackRate;
};

#endif // SABASBOOK_H
