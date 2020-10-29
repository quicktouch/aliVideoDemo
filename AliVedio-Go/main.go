package main

import (
	"fmt"
	"github.com/aliyun/alibaba-cloud-sdk-go/services/vod"
	"github.com/gin-gonic/gin"
	"initain/alive"
	"initain/global"
)

func main() {
	client, err := alive.InitVodClient("xxx", "123")
	if err != nil {
		fmt.Print("初始化失败", err)
		return
	}
	StartGin(client)
}

func StartGin(client *vod.Client) {
	g := gin.Default()
	gp := g.Group("/alive")
	{
		/*创建视频*/
		gp.GET("/createVideo", func(context *gin.Context) {
			name := context.Query("name")
			resp, err := alive.CreateUploadVideo(client, alive.CreatedVideo{
				Title:       name,
				Description: "测试描述",
				FileName:    "文件名称.mp4",
				CoverUrl:    "",
				Tag:         "天文,地理",
			})
			if err != nil {
				response.FailWithMessage(err.Error(), context)
			} else {
				response.OkWithData(alive.VideoInit{
					RequestId:     resp.RequestId,
					VideoId:       resp.VideoId,
					UploadAddress: resp.UploadAddress,
					UploadAuth:    resp.UploadAuth,
				}, context)
			}
		})
		/*刷新视频上传凭证*/
		gp.GET("/videoRefresh", func(context *gin.Context) {
			videoId := context.Query("videoId")
			resp, err := alive.RefreshUploadVideo(client, videoId)
			if err != nil {
				response.FailWithMessage(err.Error(), context)
			} else {
				response.OkWithData(alive.VideoInit{
					RequestId:     resp.RequestId,
					VideoId:       resp.VideoId,
					UploadAddress: resp.UploadAddress,
					UploadAuth:    resp.UploadAuth,
				}, context)
			}
		})
		/*获取视频列表*/
		gp.GET("/getVideoList", func(context *gin.Context) {
			pageSize := context.Query("pageSize")
			pageNo := context.Query("pageNo")
			resp, err := alive.GetVideoList(client, pageSize, pageNo)
			if err != nil {
				response.FailWithMessage(err.Error(), context)
			} else {
				response.OkWithData(resp,context)
			}
		})
		gp.POST("/post", func(context *gin.Context) {
			response.OkWithMessage("成功了", context)
		})
	}
	_ = g.Run(":9000")
}
