package alive

import (
	"github.com/aliyun/alibaba-cloud-sdk-go/sdk"
	"github.com/aliyun/alibaba-cloud-sdk-go/sdk/auth/credentials"
	"github.com/aliyun/alibaba-cloud-sdk-go/sdk/requests"
	"github.com/aliyun/alibaba-cloud-sdk-go/services/vod"
)

// 使用账号AccessKey初始化
func InitVodClient(accessKeyId string, accessKeySecret string) (client *vod.Client, err error) {
	// 点播服务接入区域
	regionId := "cn-shanghai"
	// 创建授权对象
	credential := &credentials.AccessKeyCredential{
		accessKeyId,
		accessKeySecret,
	}
	// 自定义config
	config := sdk.NewConfig()
	config.AutoRetry = true     // 失败是否自动重试
	config.MaxRetryTime = 3     // 最大重试次数
	config.Timeout = 3000000000 // 连接超时，单位：纳秒；默认为3秒
	// 创建vodClient实例
	return vod.NewClientWithOptions(regionId, config, credential)
}

type CreatedVideo struct {
	Title       string
	Description string
	FileName    string
	CoverUrl    string
	Tag         string
}

type VideoInit struct {
	RequestId     string `json:"request_id"`
	VideoId       string `json:"video_id"`
	UploadAddress string `json:"upload_address"`
	UploadAuth    string `json:"upload_auth"`
}

func CreateUploadVideo(client *vod.Client, video CreatedVideo) (response *vod.CreateUploadVideoResponse, err error) {
	request := vod.CreateCreateUploadVideoRequest()
	request.Title = video.Title
	request.Description = video.Description
	request.FileName = video.FileName
	//request.CateId = "-1"
	request.CoverURL = video.CoverUrl
	request.Tags = video.Tag //"tag1,tag2"
	request.AcceptFormat = "JSON"
	return client.CreateUploadVideo(request)
}

func RefreshUploadVideo(client *vod.Client, videoId string) (response *vod.RefreshUploadVideoResponse, err error) {
	request := vod.CreateRefreshUploadVideoRequest()
	request.VideoId = videoId
	request.AcceptFormat = "JSON"
	return client.RefreshUploadVideo(request)
}

func GetVideoList(client *vod.Client, pageSize string, pageNo string) (response *vod.GetVideoListResponse, err error) {
	request := vod.CreateGetVideoListRequest()
	request.StartTime = "2018-12-01T06:00:00Z"
	request.EndTime = "2028-12-25T06:00:00Z"
	//request.Status = "Uploading,Normal,Transcoding"
	request.PageNo = requests.Integer(pageNo)
	request.PageSize = requests.Integer(pageSize)
	request.SortBy = "CreationTime:Desc"
	request.AcceptFormat = "JSON"
	return client.GetVideoList(request)
}
